class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "adb3cf459d36c4372b5cab235506afcba24df175eca87bb36539126bb1dbf64e"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7e2e971ea2d91fd0d388784c7435045a2d80ab6d5d91edf3fb79cfa9b65dd22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c667724c0478647ef04487e67759737ea73957e56f04d58b8aa9eec133532bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b50f640dc6a718a33bf69cd1320d9c437acbfb46693dbadcc1577797ef3864ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "52c7d81cc5346eebc4f752970bbccaa955d553baa8ea2f2b5aef454b99c173c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9ec8e8a527a8191d00e2a6a09c6fc80f0475b6bad877331f661cf8067aa44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d764f83d254017ec95bf389ffe2e15bdcb7f711eb641bcaf119a6938478d40d"
  end

  depends_on "go" => :build
  depends_on "yarn" => :build
  depends_on "node"

  # Bump `node-gyp` to v10+ to avoid requiring distutils
  # https://github.com/sundowndev/phoneinfoga/pull/1512
  patch do
    url "https://github.com/sundowndev/phoneinfoga/commit/6a5b3cc849f989fe390170a127e22d990ba5c122.patch?full_index=1"
    sha256 "07ec8c3255c2183f6f42286ae498625cd51041c27a7c44130151a772d31bfcd6"
  end

  def install
    cd "web/client" do
      ENV["npm_config_build_from_source"] = "true"
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/sundowndev/phoneinfoga/v2/build.Version=v#{version}
      -X github.com/sundowndev/phoneinfoga/v2/build.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phoneinfoga version")

    system bin/"phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end
