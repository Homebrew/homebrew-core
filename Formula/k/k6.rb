class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "761e7965827754e5a7b0ef8d9bf8c3c45418aae0bac4bcc2a3d4d9ce75f0ef67"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df2cee84a58df784f0ae7efa814d2ab7f55e4f6b9d02d04eb662ab1e71f94e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d3b1b214938590b338cd234db6d584ffb16bc86c1936cbe5516a1202ddb9413"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "180661fb3d1724a465a664e7d28864376e72236df4da0b97255bff8ffe3e4a68"
    sha256 cellar: :any_skip_relocation, sonoma:         "0169e63ae6244217cdd0c90d7830c60e76ee73a032a76cd76e4f78cf1be47906"
    sha256 cellar: :any_skip_relocation, ventura:        "a82904dccf27417328472ba285c34ca891fe42fb082d6acb7a147bdc39a144db"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c4f5c8232122a2a2808ad96dfdfdc81916b736e8b164104719e40839299b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c7bcc7350a5a9ad735ad594faa379772f8751e1c9350f8dc7721d0a0ff555f5"
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
