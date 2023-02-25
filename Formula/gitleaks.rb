class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.15.4.tar.gz"
  sha256 "3628c97b4415b4c1ea23b65f427b6563224e57e42519f19c451d962574bda09e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f6235d3788ea942939f6efc03c2d5f1d0766f31dcce6ee52f950e559e7f0f3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90d6ce126ddafc5bb33123d3c57d9cd037532d380ff2866d1f751e9def70b053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53b7f5e81c97408987f09b20bd0a0e14b827d8de38a30cd4ea8243e4c8c26214"
    sha256 cellar: :any_skip_relocation, ventura:        "8c5a6f67ad32bf58e2a81f290c920f7042af292c73f460bdd9fc7fc1cc181cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "d18e72d53b57f2d7a5ba6ee7e1fe6293f4df7008eb88b491386698f5cd6db479"
    sha256 cellar: :any_skip_relocation, big_sur:        "8763879cbc01455cbc0bf0ebd978d040c96060b875b1f0213634330175b70170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75091da17cefa364e6a402e4ea340c6a6be2a78d25160ff70929ea658ae4a7e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
