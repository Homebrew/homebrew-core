class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.22.3",
      revision: "154bf56899228e5c95fb3176b9c6901bbe4ca97b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa152b482994174f3ea5582caeb5674e22e5390dced68cce594f95b29644ac9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d38c87a9fa5b835c7c13054677da890b446fa6128d8f3d83fd81aab1b1000c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e93703cda60780cb19fe06adfff30cc3ae47f3c427c67d069a101385e4199fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b31399352d4faab38b09d24f8dfabbbb0a625c2639c75162e974b0db1b1550d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82829ed3e6a53242459ff107c1ef096dbb1ea7f388e399626f7993fa135d53bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae8a88153ab2bc98543b57a5b6b8e5ca6d2a9bfa090fe5dba92ca23dfd1a9b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kopia/kopia/repo.BuildInfo=#{Utils.git_head}
      -X github.com/kopia/kopia/repo.BuildVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kopia", shells:                 [:bash, :zsh],
                                                      shell_parameter_format: "--completion-script-")

    output = Utils.safe_popen_read(bin/"kopia", "--help-man")
    (man1/"kopia.1").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kopia --version")

    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    system bin/"kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_path_exists testpath/"repo/kopia.repository.f"
    system bin/"kopia", "snapshot", "create", testpath/"testdir"
    system bin/"kopia", "snapshot", "list"
    system bin/"kopia", "repository", "disconnect"
  end
end
