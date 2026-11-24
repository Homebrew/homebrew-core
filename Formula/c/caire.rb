class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "caad6520cc42a17216d5cd95f18cb778d42844468cfb1405e5bee71d36f023c6"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    manifest_sha256 "68074454522950f04d5b6a5de87f2d7dd019693bbc180c190e27ed782a8aca2d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11a1ee28dbf61d888d0450e8552f9efa303cc64fb47bc02d3612d09b7e7566a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02acaf95303772d66003245f6d9a7404bbdb22277ceadc7ea8bd18a4d59f3170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68626f375331041ad4e6c104fa0dbbaec3cf45f0f9cff98bc33fa1cf771e2bbd"
    sha256 cellar: :any,                 arm64_linux:       "69ed543fc5e65b8d6dd0590013dbafe674a6096fa1be4dad8107e6ef090365b3"
    sha256 cellar: :any,                 x86_64_linux:      "6a5e78c69d85e468bef1e9c094e3370e11a40d269f069b78b27e2c40ec24adec"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for gioui.org/internal/vk)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
                        "-width=1", "-height=1", "-perc=1", "-preview=false"
    assert_path_exists testpath/"test_out.png"
    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  end
end
