class OsxCpuTemp < Formula
  desc "Outputs current CPU temperature for OSX"
  homepage "https://github.com/lavoiesl/osx-cpu-temp"
  url "https://github.com/lavoiesl/osx-cpu-temp/archive/refs/tags/1.1.0.tar.gz"
  sha256 "94b90ce9a1c7a428855453408708a5557bfdb76fa45eef2b8ded4686a1558363"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c7b0f3f1f33e64d4cacb4b5b8d5a7454fc23338f15caa577658ef1e0b7f3026d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e1484688d7c45ad319e94d86b098150df1a028fb85b93591664a8f5c839a1383"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50aa80f9561f2a41d78f87f5ba9998a406b3865d5bc61fcea208ead214149c64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5189807136b9dce5f62994ea3451ab91f560fcdd665e35f50387c19667af17d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49df01d45be6aa2740ee6e4be207d34586eb84626610fdd53c723d4e071e4f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d072b980bb252ce0c91fbfafdbcf20f0119d003cbfe35779c78fc262fec8a509"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dac01ceb80b82ad667893555703aa9ef19b1ee8c86e4d03485d94e4e02d7824"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee650236f7418567dc7544586870cd82902ebe42572df55c0170c5e22c38d44"
    sha256 cellar: :any_skip_relocation, monterey:       "734f1c9e1d3e8486d862fc2186ba476807d3a8da54c5cb673d6ca3c29db59b09"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4bcaab258eb1c75078e767a24c615bc82274e672ce6fd15c2a766b0b0bd8a46"
    sha256 cellar: :any_skip_relocation, catalina:       "e1df41402ed817941f591a5cc094fe4491b092de8d5177dd363eccecff811bec"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "osx-cpu-temp"
  end

  test do
    assert_match "°C", shell_output("#{bin}/osx-cpu-temp -C")
  end
end
