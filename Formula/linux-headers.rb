class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "http://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-3.18.27.tar.gz"
  sha256 "35618751139c2ad76298dd5e2e4b80121c1a14f490375bc93a35b9f0b882d29c"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ee87dd44d9a8adc3984bd589598f8e7a3b256863b0f6e895ee90f8a46e54bd6" => :x86_64_linux
  end

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    system "ls", include
  end
end
