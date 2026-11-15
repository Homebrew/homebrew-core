class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/refs/tags/v2.38.2.tar.gz"
  sha256 "02c5e873e9ebcf2798513f7dd3775e5b8aace99bfa1e0c1b93091b6d4cbcaffb"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "c460fc9862ca2614bb9c9ea520dc7b132289e073b0569c15d327e424ec8906b6"
    sha256 arm64_tahoe:       "b92163a782c058393fd678a546c6cabf11788cc5a4da73ecc078db1b37e770d1"
    sha256 arm64_sequoia:     "6f0003e43f84ae7474e40bb56eba5e1f54bcf10694f71dd01ee2b3d4af92c496"
    sha256 arm64_linux:       "d67158c1d4ceab9d49ae960708ea200900b4d80c2d1d6bcd9ec42186206ed741"
    sha256 x86_64_linux:      "cccbbfdc7d35b21af86d2c237707976ca4a290ac419d27c94d4d8c5a5d36759a"
  end

  head do
    url "https://github.com/direnv/direnv.git", branch: "master"

    depends_on "go-md2man" => :build
  end

  depends_on "go" => :build
  depends_on "bash"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{formula_opt_bin("bash")}/bash"
  end

  test do
    assert_match "No .envrc or .env found", shell_output("#{bin}/direnv status")

    ENV["TEST"] = "failed"
    (testpath/".envrc").write "export TEST=passed"

    assert_match "No .envrc or .env loaded", shell_output("#{bin}/direnv status")
    system bin/"direnv", "allow"

    assert_match "passed", shell_output("#{bin}/direnv exec . sh -c 'echo $TEST'")
  end
end
