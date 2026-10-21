class OpensslAT4 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl-library.org"
  url "https://github.com/openssl/openssl/releases/download/openssl-4.0.3/openssl-4.0.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/openssl-4.0.3.tar.gz"
  sha256 "325b5c806167c13b40b1ffeadfe0248197c00eccc4cf123ec1e28d2d2fd216d9"
  license "Apache-2.0"

  livecheck do
    url "https://openssl-library.org/source/"
    regex(/href=.*?openssl[._-]v?(4(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "cfe1f3ee8ddafdb7f19fe4d4dd600e2b84257df4fa09a169ccb7322d38483f90"
    sha256 arm64_tahoe:       "39fb74d25429fbb9794cf4327530ba458b97d0000406715270d3b0715bd6ba35"
    sha256 arm64_sequoia:     "e9968c63732a4aa642c6131f120d0a89a119885f7ce3cfec796ae672369b98a6"
    sha256 arm64_linux:       "5ab5831952c0fd3b0fe948a2068b04495f8c614e70afe4bbc868a618ef129b1e"
    sha256 x86_64_linux:      "c046045831b56b72198570373a6010bcb14d39c475d4f10e2e26665abc936e34"
  end

  depends_on "ca-certificates" => :no_linkage

  uses_from_macos "perl" => :build

  link_overwrite "bin/openssl", "include/openssl/*", "share/man/man*/*ssl.gz"
  link_overwrite "lib/libcrypto*", "lib/libssl*", "lib/ossl-modules/legacy.*"
  link_overwrite "lib/cmake/OpenSSL/OpenSSLConfig.cmake", "lib/cmake/OpenSSL/OpenSSLConfigVersion.cmake"
  link_overwrite "lib/pkgconfig/libcrypto.pc", "lib/pkgconfig/libssl.pc", "lib/pkgconfig/openssl.pc"

  # Tests require an internet connection
  allow_network_access! :build

  def install
    configure_args = %W[
      --prefix=#{prefix}
      --openssldir=#{pkgetc}
      --libdir=lib
    ]

    arch_args = []
    if OS.mac?
      arch_args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      arch_args << "linux-x86_64"
    elsif Hardware::CPU.arm?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    pkgetc.mkpath
    system "perl", "./Configure", *configure_args, *arch_args
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "HARNESS_JOBS=#{ENV.make_jobs}", "test" if build.bottle?

    # Remove HTML copies of manpages
    rm_r(share/"doc/openssl/html")

    # Compress manpages to reduce installation size
    # TODO: brew should compress manpages by default similar to Arch, Debian and Fedora
    symlinks, manpages = man.glob("man*/*ssl").select(&:file?).partition(&:symlink?)
    Utils::Gzip.compress(*manpages)
    symlinks.each do |symlink|
      ln_s "#{symlink.readlink}.gz", "#{symlink}.gz"
      rm(symlink)
    end

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| pkgetc/subdir/".keepme" }
  end

  post_install_steps do
    symlink "{{etc}}/ca-certificates/cert.pem", "{{pkgetc}}/cert.pem", overwrite: true
  end

  def caveats
    <<~EOS
      To add additional certificates, place .pem, .crt, .cer, or .crl files in
        #{pkgetc}/certs

      and run
        #{bin}/openssl rehash #{pkgetc}/certs
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_path_exists pkgetc/"openssl.cnf", "OpenSSL requires the .cnf file for some functionality"
    assert_path_exists pkgetc/"certs", "OpenSSL throws confusing errors when this directory is missing"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end

    # Invalid cert from superfish.badssl.com
    bad_cert = <<~PEM
      -----BEGIN CERTIFICATE-----
      MIIC9TCCAl6gAwIBAgIJAK5EmlK7Klu5MA0GCSqGSIb3DQEBCwUAMFsxGDAWBgNV
      BAoTD1N1cGVyZmlzaCwgSW5jLjELMAkGA1UEBxMCU0YxCzAJBgNVBAgTAkNBMQsw
      CQYDVQQGEwJVUzEYMBYGA1UEAxMPU3VwZXJmaXNoLCBJbmMuMB4XDTE4MDUxNjE3
      MTUyM1oXDTIwMDUxNTE3MTUyM1owajELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNh
      bGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDzANBgNVBAoMBkJhZFNT
      TDEdMBsGA1UEAwwUc3VwZXJmaXNoLmJhZHNzbC5jb20wggEiMA0GCSqGSIb3DQEB
      AQUAA4IBDwAwggEKAoIBAQDCBOz4jO4EwrPYUNVwWMyTGOtcqGhJsCK1+ZWesSss
      dj5swEtgTEzqsrTAD4C2sPlyyYYC+VxBXRMrf3HES7zplC5QN6ZnHGGM9kFCxUbT
      Focnn3TrCp0RUiYhc2yETHlV5NFr6AY9SBVSrbMo26r/bv9glUp3aznxJNExtt1N
      wMT8U7ltQq21fP6u9RXSM0jnInHHwhR6bCjqN0rf6my1crR+WqIW3GmxV0TbChKr
      3sMPR3RcQSLhmvkbk+atIgYpLrG6SRwMJ56j+4v3QHIArJII2YxXhFOBBcvm/mtU
      mEAnhccQu3Nw72kYQQdFVXz5ZD89LMOpfOuTGkyG0cqFAgMBAAGjLjAsMAkGA1Ud
      EwQCMAAwHwYDVR0RBBgwFoIUc3VwZXJmaXNoLmJhZHNzbC5jb20wDQYJKoZIhvcN
      AQELBQADgYEAKgHH4VD3jfwzxvtWTmIA1nwK+Fjqe9VFXyDwXiBnhqDwJp9J+/2y
      r7jbXfEKf7WBS6OmnU+HTjxUCFx2ZnA4r7dU5nIsNadKEDVHDOvYEJ6mXHPkrvlt
      k79iHC0DJiJX36BTXcU649wKEVjgX/kT2yy3YScPdBoN0vtzPN3yFsQ=
      -----END CERTIFICATE-----
    PEM
    output = pipe_output("#{bin}/openssl verify 2>&1", bad_cert, 2)
    assert_match "verification failed", output
    refute_match "error:80000002", output
  end
end
