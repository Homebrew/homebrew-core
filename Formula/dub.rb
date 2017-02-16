class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.1.tar.gz"
  sha256 "e880cf9ca6234f751a53a427eba71b8d5585b6b660d6a489458f638d2ff60554"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "f286985ce85ceb50e94011ce34b049ae4a5be725a53ca638ebb4e984ca3df8e9" => :sierra
    sha256 "f286985ce85ceb50e94011ce34b049ae4a5be725a53ca638ebb4e984ca3df8e9" => :el_capitan
    sha256 "c5321228092bf1ad8c22ac3c822cf06f92bb3a5dc4844b944929e0365a4bce65" => :yosemite
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version")
  end
end
