class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.18.tar.gz"
  sha256 "b3293074a62542c0ba54bd246391f9e38e0d48ea80c222bf8112469cb97a550c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "fb3b743c7ca1d6029ad5a3fb3d02b45220422c002898e8763a8a4da39e140987"
    sha256 arm64_ventura:  "374c7343ae15293dc66bbb995a0c84a8fb22dad58b9f883a58371ac1c0fa5578"
    sha256 arm64_monterey: "dc45e435fff09e28fc27e7c0332eaa9e28ac81d21ec5a8b500d697bac4e64be3"
    sha256 sonoma:         "475d8a88c0d7885623f5a5c73d4039073c817b8c175f4204fca41a0a6fc1e558"
    sha256 ventura:        "2e43de946b15b02e5ba42023ca6eeaffb8790b4deeffc0223d188c11ebf072ce"
    sha256 monterey:       "11faa1c3405b8dd9ccb2948224e5b58c280a36ff3bb9dccff0b1e9e2f08da05c"
    sha256 x86_64_linux:   "5af4a9451d8190310a0e7e8444fbf54dc32b21c80cf044fe8a34a7b3c0c53e1e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
