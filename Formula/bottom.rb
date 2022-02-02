class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.8.tar.gz"
  sha256 "4e4eb251972a7af8c46dd36bcf1335fea334fb670569434fbfd594208905b2d9"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a28ac019ba285bcf7647ab12cfb763dee8bee61d558016bf9126b10b1bc3cfee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2775ecb39e9041ba6c6b759b339896c0a8db89e58cb9dc17d61e9b94c2efe8e"
    sha256 cellar: :any_skip_relocation, monterey:       "4e62a3c98dbe25c38c1a392ebf8fc462c21adcd162cc5f9b724ea385756491df"
    sha256 cellar: :any_skip_relocation, big_sur:        "730ba8ae598420883843bbbf3a8ccd6226c866c6ccb496ff9a4786b312755dc7"
    sha256 cellar: :any_skip_relocation, catalina:       "4852626bd5223cafd1521d9877338cfae13eeab3aee9389e7ce41180ab333cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8def55a9974e13a13618f057b82e778d54e32f0aa3ad5a868711e12ede6a45c"
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
