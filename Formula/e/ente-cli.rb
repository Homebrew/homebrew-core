class EnteCli < Formula
  desc "Utility for exporting data from Ente and decrypt the export from Ente Auth"
  homepage "https://github.com/ente-io/"
  url "https://github.com/ente-io/ente/archive/refs/tags/cli-v0.2.3.tar.gz"
  sha256 "6bd4ab7b60bf15dd52fbf531d7fa668660caf85c60ef8c4b4f619b777068b4e3"
  license "AGPL-3.0-only"
  head "https://github.com/ente-io/ente.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02768405fae7635b534b796b20d1ac47d97688d6f9b52b84f2d0d295b85c646b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2efd5893df437f97c91a84d69d855629921325f6f397c84be29d072723019d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2efd5893df437f97c91a84d69d855629921325f6f397c84be29d072723019d91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2efd5893df437f97c91a84d69d855629921325f6f397c84be29d072723019d91"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fa97a816bcae266536982077798393b61a08859cfb455fee6a822640f8837ee"
    sha256 cellar: :any_skip_relocation, ventura:       "9fa97a816bcae266536982077798393b61a08859cfb455fee6a822640f8837ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6698caaf273ea5141fec0ad91777d7e85f73f640b186c3332cea1a9513433fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fad672f160147e34db13a96d0867946b3cd5ac076d295eef48b4b3b485d8ace"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"ente"), "main.go"
    end
  end

  test do
    if OS.linux?
      assert_match "Please mount a volume to /cli-data/", shell_output("#{bin}/ente version 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/ente version")
    end
  end
end
