class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "0fd7beadf347693f24b843496a20f92ed465c98dff2673fa9d173a8a3ecde3ef"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f34c9f0e17fac2d8988d78a89c153294d646e05fd420c5cf246493a113f95d57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c68dc21ec858f98424ed234f5df4f1cf4a9ff23dfde07535ba02acc5b9ac9442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03071f86524d2ab6affbb5bbbf4f20c3ccfd75acb7444de1f06ce8e7eee31a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86a2c0e195789305a4b4358c568d4beb27945914b275686be2143a84a5222138"
    sha256 cellar: :any,                 x86_64_linux:      "561440ee5e1c67fde691c12e99c0e188c834a77b9a67641041cf90a1e346c6e9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
