class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "1955f47cd6aad444d350aa2ca04b508852e4875089438063de4c6374f1369d4e"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2df871a516cf64abd18a14acf6a6156f8bdbd18fadd4822e732a1218f682d78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff63bc8093cf49ac8c71fa4bf24e779be7fd8f46a4654cc0d840912525a34033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aca74ce2d9575c59519ef5b76d42239af4b8a35e5346f063f909694ffe71b34"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f0ffa43c57654eb393b2cec6ae42124b3c1392eb0d63d2353fad83607d8c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c3a139899599c9126179e5202f3395e444fc43f9f411f72a3d3254f24801a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81500db3f9bd209a8bdd9562e96f63464b1b9669f50a32a656b74c2070e4429d"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
