class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.3.2.tar.gz"
  sha256 "6542be59f1fdb6a18bfce178e407e5196ac7f57471fd5dcf1b747d0d902430cb"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2243fa2e76a710d882b2ee3a7430c2ff2d22be0a299a7848a4be9cab3931483"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "132f9bffe79baee2560b6d1585485dfd63891c7f786690ba460956f7803298fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f58e42399f4d39272b1eda361ea18b7afb91fe56d93c1d7689b3b5cf13df6dbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee7eece11a1db1ab2ce2b9c6b7b49ec64a9f7ed3a3b3c59fb6440ebf341f249c"
    sha256 cellar: :any_skip_relocation, ventura:        "9b9b95abef174fa48dab6c996a56a9a1217e435436c9f62be23cd7533bc732f2"
    sha256 cellar: :any_skip_relocation, monterey:       "8d21135e20ec4fcf07c27f35075dafd999bbfef927f55661ac2f0e8be2d27741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8910125f93c06e70669a396272165a06108022bd49efcdf4fefbc07eef6f2c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/mise exec nodejs@18.13.0 -- node -v")
  end
end
