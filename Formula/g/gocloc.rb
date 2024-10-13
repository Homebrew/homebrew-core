class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c8f95201bc6042767de7059cfd6a2a37799b3bf909ec61029baffe0f6ccc509d"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1d9d4db071862619096979273f662e01ba18d2f8ab81f65368ed619019b058ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d6658082d193feb28911a88898be12e99dad08122b8e4a7361c9bda70758b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d6658082d193feb28911a88898be12e99dad08122b8e4a7361c9bda70758b9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6658082d193feb28911a88898be12e99dad08122b8e4a7361c9bda70758b9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7879e256399be4c19ea6973d142153c69cc16ec1da1ddda118806337baf774f"
    sha256 cellar: :any_skip_relocation, ventura:        "b7879e256399be4c19ea6973d142153c69cc16ec1da1ddda118806337baf774f"
    sha256 cellar: :any_skip_relocation, monterey:       "b7879e256399be4c19ea6973d142153c69cc16ec1da1ddda118806337baf774f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea39420e5d5b63e1eef76ebe1240c5bd69efc689f35c262355d6ca03d3735368"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gocloc"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_equal "{\"languages\":[{\"name\":\"C\",\"files\":1,\"code\":4,\"comment\":0," \
                 "\"blank\":0}],\"total\":{\"files\":1,\"code\":4,\"comment\":0,\"blank\":0}}",
                 shell_output("#{bin}/gocloc --output-type=json .")
  end
end
