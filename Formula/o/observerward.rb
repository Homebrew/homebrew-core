class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.6.5.tar.gz"
  sha256 "7edf8db2e601b9d240bd847541c40e7001e6223344c181da7e7aeb80dcb22d72"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9577e53d522d64463c5d9dd71ed249c0e6b15ebaa7947f092c4883fcc693bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80360761860259008435c8a14b651c29d176158f11395832abb8ed8e85765e47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d51ba2b0e1d31c365c50ed7521b4163b5092a482572e82a010333e82b32891db"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ca31db6a4219cf54f6a78d196b643682f40d730f40126cfdda27cdb23c030a"
    sha256 cellar: :any_skip_relocation, ventura:       "31c1921772d357f0282fba0231d6e32f3fd42e78e11944eaf616fcd253488628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5492c7bda875b5e31d79b0d055299743c011f5906f31e666b0d6c3550bff5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e5eb721b0bac0cff945e2c75177cdb605d846b4331347dd3f4435f3c016ecf5"
  end

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
