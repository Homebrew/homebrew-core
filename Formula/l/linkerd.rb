class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "version-2.20",
      revision: "eadc1acf79ad2e766afbdceadb77f1594296fd77"
  license "Apache-2.0"
  head "https://github.com/linkerd/linkerd2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be2585052db28e5b9762789e694938d42ef5ac168e900e0186e25f84d0645237"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3f1493693e431d57204f5a426c6237eb7e90daeb4bca2b655f13535efafaf19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7356359d889a89f9b4879faaec0b00b799e927be9cb0b2f96c8456328ded6fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "357796931b769b422ef97618f21ecd2d8ce6dd317d5a5e7436bcded08bef5358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bee15b58d9158d85aee80bce0739ff81663525be7d8c09147a25d3405c3ce0a6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
