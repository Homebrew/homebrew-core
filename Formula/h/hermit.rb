class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.44.8.tar.gz"
  sha256 "9bc7a4142e0d10cccefbb637e9d3be46b441c8e80614044ab0d8940470b610d4"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56a205c2ccedf1190954e940fa8eccd675f6a2944e9302b2603344713c5a1ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ea3e9c3d486fcd9e22923d7b81569a16895bdc400fd22651cb4681fce5d1691"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6e2e0b2a7fcf04e3d8e0a9c500ac93b7467c3088d94ec56a08570c3b70cce78"
    sha256 cellar: :any_skip_relocation, sonoma:        "576cc5864a37c0b780e77b6ac7b87837a19eee8108992697c431154eff65bf4d"
    sha256 cellar: :any_skip_relocation, ventura:       "7b9364cea9afe0265d4526b94a6b9792c7309167ec34136afddd12892474a5e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e30f258d750c56d219dd2c21a332721cc23a7daaf042da650210b65405803d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded6a6a78f7547f5d75c7f201b20c44d93e14905e598110bc4ec11d97c102f66"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
