class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.30.0",
      revision: "ee6866911663485d94c1e7ff99e607c15f2110be"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a13aa9442869cd7cd46c9f6ec86b7346177e93981ecfea2f723d2b9bcbfba347"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e010af9bbc8615097befd17d72551f6271399e0ba6bf17d09b3f8a81e681b1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67f388251920e35eca0d28e175cf902e1add3d37ec46fa563a6959ed02bf26ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e062c34cde10264f2bcad3bb22e38e5dd102d838d58b6e36d5acb9b158006003"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dac792ffdb44afe580efbd5abb71c13c7aff5a2184f705e517ff22a973c149a"
    sha256 cellar: :any_skip_relocation, ventura:        "6725b604ba0003035986bc7be6399fb6731341d8f3b96f087ab0a68432e87093"
    sha256 cellar: :any_skip_relocation, monterey:       "1015c4823f4055a8c9b9b1824795e7a269c009991f4cdfa02d1bbc309118edba"
    sha256 cellar: :any_skip_relocation, big_sur:        "07ef8d0e683d2f9ba8276461554e5950333809739e016b3bad6a8d7b449b52b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df45f8885b351219f6f7e47b284a39d42690e3efc71049ffaeec8cf58935528f"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"

  uses_from_macos "python" => :build # required to compile .pb files
  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  fails_with gcc: "5" # for C++17

  # We use "753723" network with 15 blocks x 192 filters (from release notes)
  # Downloaded from https://training.lczero.org/networks/?show_all=0
  resource "network" do
    url "https://training.lczero.org/get_network?sha=3e3444370b9fe413244fdc79671a490e19b93d3cca1669710ffeac890493d198", using: :nounzip
    sha256 "ca9a751e614cc753cb38aee247972558cf4dc9d82c5d9e13f2f1f464e350ec23"
  end

  def install
    args = ["-Dgtest=false"]

    if OS.mac?
      # Disable metal backend for older macOS
      # Ref https://github.com/LeelaChessZero/lc0/issues/1814
      args << "-Dmetal=disabled" if MacOS.version <= :big_sur
    else
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end
    system "meson", *std_meson_args, *args, "build/release"

    cd "build/release" do
      system "ninja", "-v"
      libexec.install "lc0"
    end

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "Creating backend [blas]",
      shell_output("#{bin}/lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Creating backend [eigen]",
      shell_output("#{bin}/lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
