class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.6",
      revision: "ed223bc820ee9bb7005a333013b86203a9e1bc23"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96f9647d9cd3400423c68e474b01d8b22e75097e56f7a16455dc9abc0ac13b15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc89e8b7d5d53f2ad82ac2582ae7a00081ebe402dbd42ea2c345a3c1291c37ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1034aef083259862745407d9b128f29e40f4a74fdd8c9cd8980b1af1eb6cdc7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19f81cc252ad3305798473734004a95dd1eb170bf59edeb0338e40ae9864d2d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "48f32a95020a2820cf174d8f407d8c751fd5e815af0a464a6a0063e15d2dc1d0"
    sha256 cellar: :any_skip_relocation, ventura:        "52c06edfb291561c2b1b9b965e418ea3f725a9d253c0b05451488a707db2691a"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7147315fbd3cb01cbca3c1792ff0952f12c4a1e3675078e7ae01129b79c945"
    sha256 cellar: :any_skip_relocation, big_sur:        "07b106efe5a67cbd376ac0b204097c18c60c242adeb061c914113349e4132f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dce58a0893c300f2c38905214fc550ad62b80f716cdd8086f607e263e320ade"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"
    ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
               "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
               "-X github.com/docker/cli/cli/version.Version=#{version}",
               "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
