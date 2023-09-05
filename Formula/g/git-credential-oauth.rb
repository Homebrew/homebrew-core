class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f5656771f51fa9a2e947da11e426bd724992c3fb950f42800022646a16f9978c"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ca6107887d009f0bbf63cec6dc76c47f79e4bf8e3391ec15f6e4fa5806774d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dfd9b05498af0fbfd6b1334f51fa94b7280c839045ac1f5b2add507706722b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c57a4b73f0e492430de041ba932d95a0a1b1ecea996f5d9a328bd59cb2bb0476"
    sha256 cellar: :any_skip_relocation, ventura:        "0b1f1cd30a23363b58f0ff4528a2851fd60f0181d490699223d5ab951dbe3545"
    sha256 cellar: :any_skip_relocation, monterey:       "5d3923ccec91541b27fb7bf9dfd2ff4d292a477bf90295479fa8f1d7efa82824"
    sha256 cellar: :any_skip_relocation, big_sur:        "89f82da0f6532c5cde0ba82769ca64a8adc3bf0daa9c55a424ae2fceb2f23db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56ee5f51df899df44d6ca15c8f05865b123618adf89cb9e85d34b997b0183ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-oauth", 2)
  end
end
