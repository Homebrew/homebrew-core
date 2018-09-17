class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v3.0.18.tar.gz"
  sha256 "c13c30969c5cb73fe7fbc449b17a6f69ce485335caf6da30303cac12960699e4"
  head "https://github.com/nodenv/node-build.git"

  bottle :unneeded

  depends_on "autoconf" => :recommended
  depends_on "openssl" => :recommended
  depends_on "pkg-config" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
