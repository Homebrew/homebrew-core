class InteractiveRebaseTool < Formula
  desc "Ncurses sequence editor for git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/0.7.0.tar.gz"
  sha256 "08e5d6dd9beacf7806abd74edfa9e7654ccb2ffc083b2fd8617d132951eee5bd"

  bottle do
    cellar :any
    sha256 "dcf42e55363693fb261582901be1447ce5230504353ccaca773cbc6261fc456c" => :mojave
    sha256 "693a7b57bb2ea854153cfa49d18099e1c56ff06edcf1fc1a0ee8486665a3c70e" => :high_sierra
    sha256 "9673e43caccc0d51939cfdab6bf8ebf03b7e2a4d6c46eaf7ac9e70f0727ea9aa" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    require "pty" # required for interactivity

    (testpath/"todo").write <<~EOS
      pick aaa Added tests
      fixup bbb Added tests
      pick ccc Added tests
    EOS

    correct = <<~EOS
      drop aaa Added tests
      fixup bbb Added tests
      pick ccc Added tests
    EOS

    PTY.spawn("interactive-rebase-tool", "todo") do |input, output, _pid|
      input.gets # get the input each time to simulate interactive tty
      sleep 0.1 # sleep to give the tool time to update state
      output.puts "d" # send lowercase d to interactive-rebase-tool to drop top commit
      sleep 0.1
      input.gets
      sleep 0.1
      output.puts "W" # send uppercase W to interactive-rebase-tool to write the file
      sleep 0.1
      input.gets
    end

    assert_equal (testpath/"todo").read, correct # assert the todo file is modified correctly
  end
end
