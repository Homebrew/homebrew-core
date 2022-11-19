class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.8.tar.gz"
  sha256 "4e4eb251972a7af8c46dd36bcf1335fea334fb670569434fbfd594208905b2d9"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "877d2e06dd2f926222b398f76d85109f518e18cabb1cd8e77d914990047c38f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7e126717b29e5317ddac5abc247bf3dc1d084f544af13af37ab4e17b66410d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cc0790f7611b7e50bb4ae22b1376a12619716f13b4f8bb406c0f2c67bf69232"
    sha256 cellar: :any_skip_relocation, ventura:        "2d80542e097eacb2f75c294807fe5f0b30a7b9fb96824d5cd9d261b75dd8a18f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8572a9b69cff3a51c94131b487d783efeeccf141dc84d15c33573d46bdbfe81"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab7573866fee9294189c90e5bec525d54652835be497a1cbf4c1c0c4b999ffa7"
    sha256 cellar: :any_skip_relocation, catalina:       "622766c0da5d44b5b7ea85ee524b16aa7b8b96366a677c6f158b8f6e35e60243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d31da37fed38b840c8cb34388da41be7398ae33c69725e6c36cd54b59cc265ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/bottom-*/out"].first
    bash_completion.install "#{out_dir}/btm.bash"
    fish_completion.install "#{out_dir}/btm.fish"
    zsh_completion.install "#{out_dir}/_btm"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: Found argument '--invalid'", shell_output(bin/"btm --invalid 2>&1", 1)

    fork do
      exec bin/"btm", "--config", "nonexistent-file"
    end
    sleep 1
    assert_predicate testpath/"nonexistent-file", :exist?
  end
end
