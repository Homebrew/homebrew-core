class NativeSdk < Formula
  desc "Toolkit for building native desktop applications"
  homepage "https://native-sdk.dev/"
  url "https://github.com/vercel-labs/native/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b5d0d37a4335be6a2e5da3ec7855938c5de46f4f3d5575b380e6110d1ccd8a38"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/native.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "zig" => :build
  depends_on "node"

  uses_from_macos "curl"
  uses_from_macos "xz"

  resource "typescript" do
    url "https://registry.npmjs.org/typescript/-/typescript-6.0.3.tgz"
    sha256 "33cd0ee1beaa8c9e9d15a9da836c62ddea4c34a42d7c2d349dbc80d94165d22a"
  end

  deny_network_access!

  def install
    sdk_root = libexec/"native-sdk"

    system "zig", "build", "cli",
           *std_zig_args(prefix: sdk_root, release_mode: :small)

    sdk_root.install "app.zon", "assets", "build", "build.zig", "build.zig.zon",
                     "skill-data", "skills", "src"
    sdk_root.install "LICENSE"
    sdk_root.install "packages/native-sdk/README.md"
    sdk_root.install "packages/native-sdk/native-sdk.d.ts"
    sdk_root.install "packages/native-sdk/package.json"

    (sdk_root/"packages/core").install \
      "packages/core/package-lock.json",
      "packages/core/package.json",
      "packages/core/rt",
      "packages/core/sdk",
      "packages/core/src"

    (sdk_root/"third_party/webview2").install \
      "third_party/webview2/LICENSE.txt",
      "third_party/webview2/README.md",
      "third_party/webview2/include"

    # stock typescript; upstream's package.json aliases it as "@typescript/old"
    # https://github.com/vercel-labs/native/blob/v0.5.1/packages/core/package.json#L35
    resource("typescript").stage do
      (sdk_root/"node_modules/@typescript/old").install Dir["*"]
    end

    (bin/"native").write_env_script opt_libexec/"native-sdk/bin/native",
                                    NATIVE_SDK_PATH: "${NATIVE_SDK_PATH:-#{opt_libexec}/native-sdk}"
  end

  test do
    ENV.delete "NATIVE_SDK_PATH"

    assert_match "native #{version}", shell_output("#{bin}/native version")

    wrapper = (bin/"native").read
    assert_match (opt_libexec/"native-sdk").to_s, wrapper
    refute_match prefix.to_s, wrapper

    system bin/"native", "init", testpath/"app"
    assert_path_exists testpath/"app/src/core.ts"
    assert_path_exists testpath/"app/node_modules/@native-sdk/core/package.json"
    assert_match "checked 1 markup file",
                 shell_output("#{bin}/native check #{testpath}/app 2>&1")
  end
end
