class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v18.09.0",
      :revision => "4d60db472b2bde6931072ca6467f2667c2590dff"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed98f2df25ff4735143d43c1f9e428f2a7d2577b7a684ac3c4da321a0d5178a8" => :mojave
    sha256 "57cc8cf1a0f1ff947ef7c5047d4d5aed4a703799235cb99e86d2679478a24738" => :high_sierra
    sha256 "7aba18b840ae091eadda46cf26fbd5200c4b3706c2cad239a7ee3a692c66ab99" => :sierra
    sha256 "90f9c41d4a57ab52cf606629d8875d5d2b602a377e30b76aa7b5d341ef444c85" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"components/cli").children
    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = ["-X github.com/docker/cli/cli.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli.Version=#{version}-ce"]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
