class Flutter < Formula
  desc "Build beautiful mobile apps easily and quickly"
  homepage "https://flutter.io"
  url "https://storage.googleapis.com/flutter_infra/releases/beta/macos/flutter_macos_v0.3.1-beta.zip"
  sha256 "a88356eb37c37e89f92698ed06eaf02d6364c50f6accea6fe793b9d04c9e0c98"

  def install
    # Flutter needs to be in a full git clone of its repository in order to run.
    # Thankfully, that's included in the tarball/zip, so just copy the contents:
    cp_r ".", prefix
  end

  def post_install
    # Something about Homebrew's post-install process removes write permissions
    # and Flutter writes to bin/cache, particularly .lockfile, so reenable
    # write permissions on the cache folder
    chmod_R "u+w", prefix/"bin/cache"
    # See https://github.com/Homebrew/homebrew-core/issues/17098#issuecomment-386031418
  end

  def caveats; <<~EOS
    Flutter expects to manage its own versions and dependencies like the Dart language and Flutter platform channels,
    so it's hard to predict what will happen if you try to use it to switch channels or self-update.

    Otherwise, like typical Flutter installations, run `flutter doctor` and follow the instructions to finish setting
    up your Flutter installation (no need to change your PATH, since Homebrew handles that):

      $ flutter doctor

    EOS
  end

  test do
    # system "flutter", "--version"

    # This doesn't work because Flutter uses shlock on macos, which doesn't
    # work with the `brew test` environment. My guess is that `brew test` runs
    # flutter with limited permissions. Flutter is set to run shlock and sleep
    # until it succeeds, so `brew test --verbose flutter` results in:
    #
    # shlock: open(/usr/local/Cellar/flutter/0.3.1-beta/bin/cache/shlock53833): Operation not permitted
    # shlock: open(/usr/local/Cellar/flutter/0.3.1-beta/bin/cache/shlock53835): Operation not permitted
    # shlock: open(/usr/local/Cellar/flutter/0.3.1-beta/bin/cache/shlock53837): Operation not permitted
    # ...etc. forever
    #
    # So just assert that it exists:

    assert_predicate bin/"flutter", :exist?
  end
end
