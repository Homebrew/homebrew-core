class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.52.3.tar.gz"
  sha256 "1767bcb83352618f40f0e377d9df9bd199d342a0e2906ecd261c44dfc631f5a6"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3baadcab15e843d79d7f207f60067803f4af1702a9f59190039f756b45448301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc6691047f335209e36965b365de325cc1f687ce1ee12ea28df19c8c19910f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af4c77ae5f2c921ef4f325b5f26ae30154bb87693dec49b003fe1cac8eb6675"
    sha256 cellar: :any_skip_relocation, sonoma:        "06493a91f3f916ca63369d0e65f329ba18507539bef8e58e0975395b503f8b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac462fc34adc0852a9a7f748a2117ccbabb5062b6f6049a0497e1f5cb22134d5"
    sha256 cellar: :any,                 x86_64_linux:  "b9404c1b5871c4866d5b8528d146ccd38f47e36c6ce8c71795736b0d9b20f0f1"
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
