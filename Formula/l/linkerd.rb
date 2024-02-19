class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.9",
      revision: "2aae59bd247914357405634650906230f7d4813a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "521965ba1a3586e4ad951082a0e312c70ca7ab2fe13a0a2f0a9a50fb0e3e616e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc499ae57c9591ecd738b576ac66c21709870f64c171a026a2e8fa7184b633c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbdb1e957772c188674f26ddaf1e625c8d05f582586b526d138ffdaac7bdb4a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca4f10795e9c24dffb7cef45a490cc60a89afe56c858c84aa88064e2da9e5ebd"
    sha256 cellar: :any_skip_relocation, ventura:        "79d6e3d1a36de61df97b84d19bc22bcc5fa422a7eb2fa411f69bd9c70551aa93"
    sha256 cellar: :any_skip_relocation, monterey:       "bf650bc6cd0ebb2ec0cffd8cd79690131470bfb0854de521139a9dd79bc46e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3202b6d250a7152ed8c3b1eb1a67072adbff9304860e580dba5c6ee7ea5ab165"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
