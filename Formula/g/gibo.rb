class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.11.tar.gz"
  sha256 "4936deda69681262510bca3d9530ad688cd4adff3d6162a52a28d3ded8c44c47"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0360b11f66c8006af2aed40a48167af327181dffc9e7036ed8d0754ab4a4c223"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afdeadaae4cba224b652207ee3dccdcb62feccd25b132c174109e8e7e6fb05d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3afb603d969bcafae79b5f95a15c7ab12008c092919a278f91871c4f18abb88e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6697903120ef72e69bc1497d40660dac9fa8dabfae64c4b1e1fc9540ade47f24"
    sha256 cellar: :any_skip_relocation, ventura:        "09cd36eebc83a53ad71757517e0b69e93804860a6337bf24736c14894bffd7e5"
    sha256 cellar: :any_skip_relocation, monterey:       "58808d56dc42f3eb34db3dfa15b67c1a385f353c57c098b740426b12b4bcafd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50fd469239a2dd4c1f6ad9414252c981dab07fb2fa6f35b97624afec55cca2dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
