class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/releases/download/v4.12/proxychains-ng-4.12.tar.xz"
  sha256 "482a549935060417b629f32ddadd14f9c04df8249d9588f7f78a3303e3d03a4e"

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha256 "d6765a74122bf1c4eee6c6fba574914d5d7ea3bc8a8213190559ca3a3710b036" => :sierra
    sha256 "d415e8d865c78168528c02b0ec1a903c0bd980a245273ad39c0e548f03301cb9" => :el_capitan
    sha256 "ee754ccf623b29e7d14ba2bd6697175ff3e1337e8637c463caab4a6a18e3d32f" => :yosemite
  end

  option :universal

  def install
    args = ["--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"]
    if build.universal?
      ENV.universal_binary
      args << "--fat-binary"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
