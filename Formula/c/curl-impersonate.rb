class CurlImpersonate < Formula
  include Language::Python::Virtualenv

  desc "Curl build that makes HTTP requests look like they came from a real browser"
  homepage "https://curl-impersonate.readthedocs.io/"
  url "https://github.com/lexiforest/curl-impersonate/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "027e0cc1efef9ff9587f7cd33da5a6a0df1eb285d860fbfd78bc86c8c45f7f23"
  license all_of: [
    "MIT",
    "Apache-2.0",
    "BSD-3-Clause",
    "curl",
    "Zlib",
    # linux-only licenses for libidn2
    { any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"] },
    { all_of: ["Unicode-TOU", "Unicode-DFS-2016"] },
  ]
  compatibility_version 1

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.15" => :test
  depends_on "ca-certificates" => :no_linkage

  resource "boringssl" do
    url "https://github.com/google/boringssl/archive/156c7b75ae9b8c3b3f847acf264f17594c3859fb.tar.gz", using: :nounzip
    version "156c7b75ae9b8c3b3f847acf264f17594c3859fb"
    sha256 "4cbd70611e6400616fd5a58f42e19e7bafd568c674ecb3a6418c43ae1e3ac93b"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(BORINGSSL_COMMIT "(\h+)"\)/i)
    end
  end

  resource "brotli" do
    url "https://github.com/google/brotli/archive/refs/tags/v1.2.1.tar.gz", using: :nounzip
    sha256 "98d35d11a78dc453aebb7d10c3748f3f73ff78c8267c0dc697b8631f67bf7e8f"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(BROTLI_VERSION "v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  resource "cares" do
    url "https://github.com/c-ares/c-ares/releases/download/v1.34.9/c-ares-1.34.9.tar.gz", using: :nounzip
    sha256 "9364b70a12eb59a06830fb488d9357f90100dff0d98b23ea3593a183d43e6f2f"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(CARES_VERSION "v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  resource "curl" do
    url "https://github.com/curl/curl/archive/refs/tags/curl-8_23_0.tar.gz", using: :nounzip
    sha256 "d0605d5883124ef5ae64c6d2b307e1417c482b362583b57491fdf37d9a99a792"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(CURL_VERSION "curl[._-]v?(\d+(?:[._]\d+)+)"\)/i)
      strategy :page_match do |page, regex|
        page.scan(regex).map { |match| match&.first&.tr("_", ".") }
      end
    end
  end

  resource "libidn2" do
    url "https://ftpmirror.gnu.org/gnu/libidn/libidn2-2.3.7.tar.gz", using: :nounzip
    mirror "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.7.tar.gz"
    sha256 "4c21a791b610b9519b9d0e12b8097bf2f359b12f8dd92647611a929e6bfd7d64"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/scripts/build-libidn2.sh"
      regex(/libidn2_version=['"]?v?(\d+(?:\.\d+)+)['"]?$/i)
    end
  end

  resource "nghttp2" do
    url "https://github.com/nghttp2/nghttp2/releases/download/v1.63.0/nghttp2-1.63.0.tar.bz2", using: :nounzip
    sha256 "607b174554d22a828bc532d1d734fe0f729b5d5ed207f2f12e96a62e83f29c55"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(NGHTTP2_VERSION "v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  resource "nghttp3" do
    url "https://github.com/ngtcp2/nghttp3/releases/download/v1.15.0/nghttp3-1.15.0.tar.bz2", using: :nounzip
    sha256 "c6c491a52804814098e446630e6efc459afc0d3da7952ffe6cbdc0b3f99b2b62"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(NGHTTP3_VERSION "v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  resource "ngtcp2" do
    url "https://github.com/ngtcp2/ngtcp2/releases/download/v1.20.0/ngtcp2-1.20.0.tar.bz2", using: :nounzip
    sha256 "871ec97ad86803cf312901b0c393b0ee70163e25a87c9b2894d1234341ce4e97"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(NGTCP2_VERSION "v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  resource "zlib" do
    url "https://github.com/madler/zlib/releases/download/v1.3.2/zlib-1.3.2.tar.gz", using: :nounzip
    sha256 "bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(ZLIB_VERSION "v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  resource "zstd" do
    url "https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz", using: :nounzip
    sha256 "eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3"

    livecheck do
      url "https://raw.githubusercontent.com/lexiforest/curl-impersonate/refs/tags/v#{LATEST_VERSION}/CMakeLists.txt"
      regex(/set\(ZSTD_VERSION "v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  resource "curl-cffi", :test do
    url "https://files.pythonhosted.org/packages/96/4c/69074f9797d83a5401b3c6bc58c5de5aad6d1a085d0497b87a093a152e87/curl_cffi-0.17.0.tar.gz"
    sha256 "31ee8500d06d6502ce1ec0b7ded1c5aa8e8f3401bbe37ccd78d6153d859d8f3c"

    livecheck do
      url :url
    end
  end

  allow_network_access! :test

  def install
    # Homebrew-specific workaround as brew audit doesn't allow zip urls in resources
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "${BORINGSSL_COMMIT}.zip", "${BORINGSSL_COMMIT}.tar.gz"
      s.gsub! "${BORINGSSL_URL_HASH}", "SHA256=#{resource("boringssl").checksum}"
    end

    resources.reject(&:test?).each do |r|
      download_dir = (r.name == "libidn2") ? "build/deps/downloads" : "build/#{r.name}-prefix/src"
      r.stage { (buildpath/download_dir).install Dir["*"].first => File.basename(r.url) }
    end

    args = ["-DCURL_CA_BUNDLE=#{Formula["ca-certificates"].pkgetc}/cert.pem"]
    args << "-DCURL_IMPERSONATE_VERSION=#{version}" if build.stable?

    system "make", "prepare-libidn2" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-P", "build/CollectLicenses.cmake"
    prefix.install Dir["build/licenses/LICENSE_*"]

    inreplace bin/"curl-impersonate-config", Superenv.shims_path/ENV.cc, ENV.cc

    # TODO: Remove if fixed: https://github.com/lexiforest/curl-impersonate/issues/297
    (include/"curl-impersonate").install include/"curl"
  end

  test do
    assert_match "curl-impersonate/#{version}", shell_output("#{bin}/curl-impersonate --version")
    assert_match(/^IDN$/, shell_output("#{bin}/curl-impersonate-config --features"))

    filename = testpath/"test.tar.gz"
    output = shell_output("#{bin}/curl_safari270 --compressed -Lvo #{filename} '#{stable.url}' 2>&1")
    assert_match "Version/27.0 Safari/605.1.15", output
    filename.verify_checksum stable.checksum

    # Make sure library is compatible with curl-cffi as dependents may miss API/ABI breakage.
    # The PyPI sdist includes curl.h so there is a risk of incompatibility with newer versions.
    resource("curl-cffi").stage do |r|
      ENV["IMPERSONATE_BUILD_DIR"] = lib
      ENV["IMPERSONATE_LINK_TYPE"] = "dynamic"

      pip_args = %W[
        --ignore-installed
        --uploaded-prior-to=#{r.source_modified_time}
        --verbose
      ]
      venv = virtualenv_create(testpath/"venv", python3)
      system venv.root/"bin/python", "-m", "pip", "install", *pip_args, "-e", ".[test]"
      system venv.root/"bin/python", "-m", "pytest", "tests/unittest", "-k", "not test_upload"

      require "utils/linkage"
      curl_cffi = Pathname.glob("curl_cffi/_wrapper.abi3-*.so").first
      curl_impersonate = lib/shared_library("libcurl-impersonate")
      assert Utils.binary_linked_to_library?(curl_cffi, curl_impersonate), "curl_cffi missing linkage!"
    end
  end
end
