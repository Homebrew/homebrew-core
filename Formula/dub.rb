class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.7.2.tar.gz"
  sha256 "1801e2d8f0069ad68ef7c63ed44dc3923a8f7617fd3c9db5e5e748846b0d79cb"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "64ce3069762775d82d1dcf93a76033f526aaccd798e7ad9c7a885fa129548d61" => :high_sierra
    sha256 "8d54d328457b23195d2d5fbe3d829fdaecb8f3c918b2cc34e24a7d10fd334acb" => :sierra
    sha256 "828a8534ea4978f508aeb63ad45c9154223f5914edbff39dd14c98c3cfd6e45f" => :el_capitan
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
