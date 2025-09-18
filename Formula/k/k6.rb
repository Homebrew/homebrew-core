class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "f89052128ccf12252fb6d58bb236e348c7f7f9afec80ca73323848a6f6af7ef2"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6f45aec156c5621af77c689a3b38eb9167e9a8619086904d63999762312b3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5305e17e6dec848193b2f8f52831d3ef68bc14b520e5f61186dd377337e87c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5305e17e6dec848193b2f8f52831d3ef68bc14b520e5f61186dd377337e87c2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5305e17e6dec848193b2f8f52831d3ef68bc14b520e5f61186dd377337e87c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41123f61400bb4dae6c80f44b01af48377527e3e1e3d129f695e11fb6a34ef3"
    sha256 cellar: :any_skip_relocation, ventura:       "f41123f61400bb4dae6c80f44b01af48377527e3e1e3d129f695e11fb6a34ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a2f69f16448e0762e9ae1f2d8c324c42bc1071a6a915648b1173f0dbe78176"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
