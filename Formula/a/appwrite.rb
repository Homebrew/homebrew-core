class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/27.1.0.tar.gz"
  sha256 "e2ee39cb635f6d8a33518afd30d7c01c4a384618364931025518183a8e3dbc6d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "461d527bae4d4d9c5ea1086e09be3020f34daa19398af59dd85de2d6f34bad98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "461d527bae4d4d9c5ea1086e09be3020f34daa19398af59dd85de2d6f34bad98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "461d527bae4d4d9c5ea1086e09be3020f34daa19398af59dd85de2d6f34bad98"
    sha256 cellar: :any_skip_relocation, sonoma:        "230a6b708f6f226797a99d08a09ff08dcf28a40dab971e02d5ffb3d7a59075b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d9db4f7bd0bac317bbd5fa2687cf26b0a6a42cefcb1679a0ab9e4b56afc7a3"
    sha256 cellar: :any,                 x86_64_linux:  "fc7e6a552e935f9ccb5bcdb242fbf6dba54cdc2435b2fd799ba782ed875491f4"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
