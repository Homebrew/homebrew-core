class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.49.1.tar.gz"
  sha256 "390bc8958b2257f6e9c2169ffba221ad53b97f0d31912bddfbda24296609537a"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d31c3d351607e8577c259cdb7117a1cf7d85dd22e3b49a6a08e9e26e7f218af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a768e3ca8a1c973be0d205e33e7db349549cea58ab7ff023fd1bd79a3bb6e749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90105fb7e9990b63bbc73310e3d625fb1d605cf0af81e956f99cd66f9376ef60"
    sha256 cellar: :any_skip_relocation, sonoma:        "44da9d50ba6c3f7dc708966ca9cfefcd34c3a35f8eae1b54957027d88a5a642a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc2c2267f4c76c40b42179df6495b5e0d1e70232b3dd9adcdceb763a5af9bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e3760a62aa5d6f984e08c6d573adf992cc57adc4941c93e4ad106809f4edf4"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
    bash_completion.install "#{out_dir}/broot.bash" => "broot"
    bash_completion.install "#{out_dir}/br.bash" => "br"
  end

  test do
    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r\n"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end
