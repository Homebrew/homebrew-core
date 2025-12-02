class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://github.com/google/gops/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "9a040fe38e45aa41cfc43be5babb5e7962b027e1f6f8b68e5112f01866a42bba"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "af565d548b9189c123da62047369e06c967a6f98a291a1dbd8c1043c5f95174f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e6424f29a0624aa928ab6604ea0bfebd30fbf1359343c94a827deb39dc32561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9705e404ae430eef52e18a9bd0efcd7aba007de76ef17d967a1da2c949e73130"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7680e1666c0a84e516a2d8cfc5882137a3ceec2f766ed52fd329c5f2381c2fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73b0acd3e244d661ad8afb34b2deae54ce4fae4ff0915a96fe74d97d869f55dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "153c588b4492ff65989099e2906417ce9653ad5d3d44268efcb616d353e181e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cbc574d3ccc11003eee6cb68d68f0e64235a84007feddcc0e5a1e154bbd9089"
    sha256 cellar: :any_skip_relocation, ventura:        "108f4f2b6f4e5f79ca47026f68830c2b9b024afd3d725b58dc8ae6e65a4dd25d"
    sha256 cellar: :any_skip_relocation, monterey:       "a65ae8fbe8e9761b3326e1b3f39dfbfa2bbcbc1156adfa012824661735c360b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e14a6d521e10aaedd20738507a2e02100d66c31b90243916ad846bd500c7bfa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82dc7c2c146110527906aa868bebda31477f7f91ad900036eac2cb459015fc78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8358b184e1d9926fb8083d0f3db365b091d18ce132d5b2732cb441c2e0aa03fb"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.18
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import (
        "fmt"
        "time"
      )

      func main() {
        fmt.Println("testing gops")

        time.Sleep(5 * time.Second)
      }
    GO

    system "go", "build"
    pid = fork { exec "./brew-test" }
    sleep 1
    begin
      assert_match(/\d+/, shell_output(bin/"gops"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
