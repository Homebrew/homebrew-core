class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "9b7c80191fa49a8c6c2b959f20d45e316171c277730e3bc99d825294b4fe2452"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6adc07c3551b37506110b4b3788d5f970b6f1ed04bdf23dd04eecb9a59d1beb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86a1a11d4b074c0cecf1ecb04c24f265d554cbaa823e017bd0c1aead26b69192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591e524f92ffb53ca7f6dec4addff60cc2932875c431adec4b097ee522df30bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d8f160996c39605f6e13e68f16faf48786f7c0c9ebd9f995807da80cc310436"
    sha256 cellar: :any_skip_relocation, ventura:        "4be2b429c7994b2d7d17cf7e72451d43afd45593e4f07edcb412d6b0944bbbe9"
    sha256 cellar: :any_skip_relocation, monterey:       "f4afc9b802b3dde03ab1d3ff13698a7ee4beef1b3b1c6b85452be3da1ed6318f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d854b9b01622a3def47c47b072ddcc0f75f71f6026953001ef2332a9d21ac095"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
