class Bashka < Formula
  desc "Static verification of installation bash scripts"
  homepage "https://github.com/dmtrKovalenko/bashka"
  url "https://github.com/dmtrKovalenko/bashka/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "352436b9932fb98ab5aacf7344ef483220309eccd43886ed51ed06c81eba48d1"
  license "MIT"
  head "https://github.com/dmtrKovalenko/bashka.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd278f5a8eb1e7130b5296c3fb67ec79231a876f17195bd47cb4c11b0c339968"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ae0f89a513551c081718890aa4bd82699e2a5b7c4241dbafd1f9babb570a392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ab403401a80ed23e813aa5b063a545cf1e95f299499dd915e6503161b6c349a"
    sha256 cellar: :any,                 arm64_linux:       "9490f634f6a728485c2adfe1cde97bfbe2a3c9e03de00b5d6654565d68a4ff94"
    sha256 cellar: :any,                 x86_64_linux:      "a867c556c9619dd9a22d37aa39c6f902acc6bfd8d711159b99889f01ef6a127b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bashka --version")

    malicious = <<~BASH
      #!/usr/bin/env bash

      rm -rf /
    BASH
    empty = <<~BASH
      #!/usr/bin/env bash

      echo Hi
    BASH

    # Couldn't capture `stderr` for some reason (`2>&1` and `open3` methods didn't work).
    # Don't match output, just check the exit codes
    pipe_output("#{bin}/bashka --check", malicious, 3)
    pipe_output("#{bin}/bashka --check", empty, 1)
  end
end
