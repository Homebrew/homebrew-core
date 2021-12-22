class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.6.tar.gz"
  sha256 "102932d73a5b053c81bb7d9a7a8af35a0da1f9f391a62a58ba5cd1702daf4429"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bdcb1f80c4ffeea330a56fb84cd1c3eb519c3f80e35de477ea479777c1443f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b45b3fa509b418b8879edc5eb285c9c86a3b8507977d95e91cb4b9836cd857b"
    sha256 cellar: :any_skip_relocation, monterey:       "f9841a994ba220db3864040ec783a7bd6c8476cf55857b034fc081fbe08d5320"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2e28ea20fc882bc2fcef97034980c3e77327efc157fadcda420448137a3d39d"
    sha256 cellar: :any_skip_relocation, catalina:       "7c6ea5a7702743b5c7f3287115fdc06b09d67761b3be0330ef8a6bd70109af81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425d514e983b3855a810cf7f3dfc0fd3ef62ea7224e7d5914ed18dd151bbee99"
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
