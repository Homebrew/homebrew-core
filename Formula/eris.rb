class Eris < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/eris-ltd/eris-cli/archive/v0.11.4.tar.gz"
  sha256 "e2eb02d01b76e8be9f28aac31b2e56ebadc4d0decb21fcfefb2f219cb03d1238"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dd142c8a5911ed924f9f84790299ed41c01e912f34fab3a5b1edfd062c6983d4" => :sierra
    sha256 "a2320c9b6b108ac65a7377b91243470b5513fa91622655036a652cdb8616c66a" => :el_capitan
    sha256 "3d62226e28cc5f9293c8a4a3dae5c3d3a865dec7e85381d36fa443455c522c30" => :yosemite
  end

  devel do
    url "https://github.com/eris-ltd/eris-cli/archive/v0.12.0-rc3.tar.gz"
    version "0.12.0-rc3"
    sha256 "7b3455b3019cc3a440e54f16ef9cda4359bc09d54f178b56b23555f97c4c7868"
  end

  depends_on "go" => :build
  depends_on "docker"
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/eris-ltd").mkpath
    ln_sf buildpath, buildpath/"src/github.com/eris-ltd/eris-cli"

    system "go", "build", "-o", "#{bin}/eris", "github.com/eris-ltd/eris-cli/cmd/eris"
  end

  test do
    cmd = build.devel? ? "version" : "--version"
    system "#{bin}/eris", cmd
  end
end
