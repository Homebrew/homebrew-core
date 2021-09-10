class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.52.tar.gz"
  sha256 "961f3a127625341183a070d91ee35840f0f6ea284d2d32534328bd9d965ff0b0"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03d266175c975d1d75155a69d6724c66c0517414cf5d5755d72a041f879d83fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9c30460a6560b70c9aa8b7d8b63ae908645272173318e24ddd0d0bbb70e91c4"
    sha256 cellar: :any_skip_relocation, catalina:      "49d8564ec902869d5843af7b9d8ab692f0f571195393e31971aaab87d104584c"
    sha256 cellar: :any_skip_relocation, mojave:        "c5a7613723cfa562db110046871851f26a6a087c70df8fe0379fda5122eeacb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d1e07da1ad33dfafc9f81fd4492ba7c082bd4f9266a788e488c1af594041b1"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
