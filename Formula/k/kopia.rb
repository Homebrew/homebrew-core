class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.23.0",
      revision: "981d5f95ad7b64f834c46b7ac244d524644fbb46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43db487495bc6161a46c200f5cfe67a7f159fc1d55bdcaed7894701ab0166d06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ed8838ef2ac718067c6f823e89236cfdbbb12986937829ffdc063ff6bd044b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042ef780cad28391325a72bc4971205647b5290d75f84784ab7bab0c1bece239"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5171ef803f616db04575391cf811503104327798f95b22374fce59525449094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6382af01fee82328f0da01c18eeb479221b201011382266fcea9b0a80a692a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a17a99640f1b71777ed63b380ae591e413cd6e297e97cb3183c719ec83dbcd"
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
