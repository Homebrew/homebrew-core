class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.27.tar.gz"
  sha256 "bfad8b9427fb665650305d577899e052d56dea02a499e82606ad0019a682988f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78520a4f162dc1a825fce796eb0a463713f5caa87bce7592adca9aa7cf29d625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78520a4f162dc1a825fce796eb0a463713f5caa87bce7592adca9aa7cf29d625"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78520a4f162dc1a825fce796eb0a463713f5caa87bce7592adca9aa7cf29d625"
    sha256 cellar: :any_skip_relocation, sonoma:        "232b783e52cef1b091baef0a17adb28dbba0752ebb250742feeba1c8a1926105"
    sha256 cellar: :any_skip_relocation, ventura:       "232b783e52cef1b091baef0a17adb28dbba0752ebb250742feeba1c8a1926105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095cf17abcb2569ecd2c18ce6651301fe2d73cb1a74683db1601c13558e1b184"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
