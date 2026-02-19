class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.59.0.tar.gz"
  sha256 "fc311566b008be3796d6f27f0e9fb90b3bccb497c4e203bc53069f46e39f94f1"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87fdc3b28455389fed5504ea59bdd234cb3983866d1f5993ec490d40afeeeaec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf0cf5391ba5be723d92bf3b8565a1893a2c59cd1f309cccbb261f21aa624ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23998706e01cf1a82c6f916286024a2f5a192b79e85707fbc11314058ec18925"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0c06d3f472cac290a906c36ee482e079243e9d865faf73640dca92ca38823b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f593e1ee829d2775638c7a6ecb5db4355c0c77c1a8f8db5ffa72fedeaabdb2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e21c1132eca41d13d0e266e7c92caa24226cb56f3250d94567b1a88dcad79955"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
