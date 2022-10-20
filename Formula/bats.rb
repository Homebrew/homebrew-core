class Bats < Formula
  desc "TAP-compliant test framework for Bash scripts"
  homepage "https://github.com/sstephenson/bats"
  url "https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz"
  sha256 "480d8d64f1681eee78d1002527f3f06e1ac01e173b761bc73d0cf33f4dc1d8d7"
  license "MIT"
  head "https://github.com/sstephenson/bats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab1210bf9790f9002e57584fb139802c79e7d0c7f6124a7024711a2998895a75"
  end

  disable! date: "2022-07-31", because: :repo_archived

  conflicts_with "bats-core", because: "both install `bats` executables"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"testing.sh").write <<~EOS
      #!/usr/bin/env bats
        @test "addition using bc" {
          result="$(echo 2+2 | bc)"
          [ "$result" -eq 4 ]
        }
    EOS

    chmod 0755, testpath/"testing.sh"
    assert_match "addition", shell_output("./testing.sh")
  end
end
