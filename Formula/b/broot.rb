class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "92f88c6051c8ed7276d43a4ab45aacfe7b0dd1d65b3503d45ba1f9dad5e95cf1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa2dee1a9f4bc486bb01b1437d579cb582a2c940bea8601bda4e1481054d3410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2272cf7bd24ea1fe14c14b9b1e94e01f639c51707dc43c165256b454fc01745c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bea1db2edb44f126dba7da189729fba1763e3933ef0bcf2ac2b343e6d49587a"
    sha256 cellar: :any_skip_relocation, sonoma:        "be917425848e6fbdc1255b3658a2800cd88358c6eb60494eff1281549e5c69e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af6dc7bb7b757a7c6ab3dfd48c64ddd940a7207a323c57d3408157d7c12202b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb1a236b35eeb3ec14106e9ed53869ed027198e2f1b9ad78eaa557287a26a64a"
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
