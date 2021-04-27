class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.28.0.tar.gz"
  sha256 "7d519fcb4d50fdaaaa77405987281484eebcb1ab4f433408df1d0a4a73896281"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0166cf3c1a108a3480f17e968ea0ff0b85925debfd9b698cd492a715492efd24"
    sha256 cellar: :any_skip_relocation, big_sur:       "c30cc387537e9fd3a8019fb7f1c4f6ddfad68bed82b135a8fab329ed4bba01e7"
    sha256 cellar: :any_skip_relocation, catalina:      "06f68e6b5caf451a9ea069033ad219011d1abeab329e20b2ccb80d4b4965ef51"
    sha256 cellar: :any_skip_relocation, mojave:        "ddee5fd6566e43db64def92fd02304f52401aa531ef3a2ee974bdf440e529fbf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
