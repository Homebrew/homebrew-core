class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "4fb912a2127bdec75ada978954b3e9a963ec6891c95657237a3e4514da02b17f"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd879cc6f72150c9d8bea936839ec55b77407e5581a0e472df792b7652d8507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdd879cc6f72150c9d8bea936839ec55b77407e5581a0e472df792b7652d8507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdd879cc6f72150c9d8bea936839ec55b77407e5581a0e472df792b7652d8507"
    sha256 cellar: :any_skip_relocation, sonoma:        "0339a193bf3694c6b8675d3daa8b380142f4f72948c0cb80b4c5859a583182f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54041c0a558aae39c7c1a9accabdfccf02d9d5f81a7a4c3ddda1a2db64becfd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "586e199ca0a108704dd49fb8b9a603eae4b88f1c385038212c0c2cea91a6d983"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
