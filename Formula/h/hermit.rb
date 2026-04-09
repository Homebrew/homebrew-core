class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "7400a8e05c39aefbdde917c82acbda164d459f3bc6d329a351b454b70815bf92"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44d4dcf8afa10ebfea935f431d95b4deaff4b40b36c76be99b76ebcf30e14389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41e6bce73115331dccf1e4880d870b6d0e6e4bd6f85492a28c2edda2bba0e37d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6ad177875e23abfd7fc31249900b9aa82900e664ad0944115d01402c9c5c293"
    sha256 cellar: :any_skip_relocation, sonoma:        "95b1a3a9976692e98a0cfd5d1ab7c72ec347c2222a26da115274d05477e154e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daace586ae5fbf745ca6f3263a301a9efb090d7969f6afb97433f1410dcaed24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f02bdc338efd575205ac9c1587f31099d436cd9983fcb54cc178da3bd9da36"
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
