class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.11.tar.gz"
  sha256 "2ff6a2746f17b00fe13ae942b556f346713e743de9a0f66208d63fe2d5586063"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba7a577a6c1f2ebaf28a80de5684cc24fd7af3d430aa56d603ba163b19c00916"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e46f51d5a1987ec539ebc77be28a006ee9c1bab20f37fbfcfd7ec6a4aa89e0"
    sha256 cellar: :any_skip_relocation, monterey:       "333b944c87bf724ca91b72aea13f087490de979366b9d9845a1b3369c60a93fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "75ffa14157483d7caee4db99341b64938f935b05643a836a8200c2e8a03f1ed7"
    sha256 cellar: :any_skip_relocation, catalina:       "a656d757991decfad9b8c4759047a8050501fe44e7fb4ca69b84c7bdfff11446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ade0f19c87a59f93c824bb3b7d28f640973a65148e729265d8e0d68c43d7045"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"goreman"
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
