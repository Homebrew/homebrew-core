class OpensslAT4 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl-library.org"
  url "https://github.com/openssl/openssl/releases/download/openssl-4.0.1/openssl-4.0.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/openssl-4.0.1.tar.gz"
  sha256 "2db3f3a0d6ea4b59e1f094ace2c8cd536dffb87cdc39084c5afa1e6f7f37dd09"
  license "Apache-2.0"

  livecheck do
    url "https://openssl-library.org/source/"
    regex(/href=.*?openssl[._-]v?(4(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "df1f1b0af55395e4b3527b2c6d94cb2372cdca8f8414a8290e33f5b1c878e371"
    sha256 arm64_sequoia: "500c12b28d754f34b36a193f3f1f8bf676e9bef0de18e641792df7a258fbad5a"
    sha256 arm64_sonoma:  "fd66bb871b71a8904acdb4770aaefba1d4bf1089b643f0fcf70f7fe21efd3e03"
    sha256 sonoma:        "e30016697c6b4686b2821c4e48c3b66e724da218424a7512ca09544eb76251b6"
    sha256 arm64_linux:   "f0b8ea03f7e55eef4cbddd7f7449f325a3334a5a650e41c3fb5103c2687e1f13"
    sha256 x86_64_linux:  "a014111c512510f60006435d7f8104e98cfbfffbfaf52e0e63252de522de7754"
  end

  keg_only :versioned_formula

  depends_on "ca-certificates" => :no_linkage

  uses_from_macos "perl" => :build

  # Backport commits to avoid test intermittent failures
  patch do
    url "https://github.com/openssl/openssl/commit/1e386aab890b52f46641ab18e1a56cabb1b8c47b.patch?full_index=1"
    sha256 "636f11a33a39536c1cc69426c73863db2b57be636b5977a4076b0995c342ef30"
    type :backport
  end
  patch do
    url "https://github.com/openssl/openssl/commit/d9f73e36c5fe720b3367e0fc6501683a3f91193a.patch?full_index=1"
    sha256 "3508588c5e03ba6d3898512f0e8e3aa1f177e243c026884d6c31020359cae59e"
    type :backport
  end

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
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    pkgetc.mkpath
    system "perl", "./Configure", *configure_args, *arch_args
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "HARNESS_JOBS=#{ENV.make_jobs}", "test"

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| pkgetc/subdir/".keepme" }
  end

  post_install_steps do
    symlink "cert.pem", "cert.pem",
          source_formula: "ca-certificates",
          source_base:    :formula_pkgetc,
          target_base:    :pkgetc, overwrite: true
  end

  def caveats
    <<~EOS
      To add additional certificates, place .pem files in
        #{pkgetc}/certs

      and run
        #{opt_bin}/c_rehash
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
