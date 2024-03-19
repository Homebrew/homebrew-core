class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "8e45fe5b6a3109003ba6dbe5aa04e16bacfd1ec12c77a6b41da48e0dcf8f4cbb"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23679486b1c34dbd340fdf80c40f8420771a7beab27ff3f3426beac3996fddd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4119bd85394bb72a2a539206c2bef0fcf225464a9b4cb1351de296f4ae81da0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "432e0604ee4616620988169e73d19e555ccac3dac205ba51cf3f4ed88c30e213"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c1f554a99ac922f7fd5712377299768660c914e5fa06dda1952b201b49b9da6"
    sha256 cellar: :any_skip_relocation, ventura:        "69132deda981505ad813a0a06b03f83d43d8892cc282142132ed9c7e1998c523"
    sha256 cellar: :any_skip_relocation, monterey:       "4c95520fd236d0bbe50c38a94394d32762cf8cb5ad323a7ef2c02a1bc106ae92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dcc59667d775e4bd0d1b35b309e74b2e10624df4c5f544a9ba6c7c257b1c22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
