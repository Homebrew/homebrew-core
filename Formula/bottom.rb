class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.4.tar.gz"
  sha256 "ee949805515a1b491f9434927ac3d297b9d5d9d261e3c39e036b725d807b10de"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

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
