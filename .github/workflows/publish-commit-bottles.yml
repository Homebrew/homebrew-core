name: Publish and commit bottles

on:
  workflow_dispatch:
    inputs:
      pull_request:
        description: Pull request number
        required: true
      args:
        description: "Extra arguments to `brew pr-pull`"
        default: ""

env:
  HOMEBREW_SIMULATE_MACOS_ON_LINUX: 1

jobs:
  upload:
    runs-on: ubuntu-latest
    steps:
      - name: Post comment once started
        uses: Homebrew/actions/post-comment@master
        with:
          token: ${{secrets.HOMEBREW_GITHUB_PUBLIC_REPO_TOKEN}}
          issue: ${{github.event.inputs.pull_request}}
          body: ":shipit: @${{github.actor}} has [triggered a merge](${{github.event.repository.html_url}}/actions/runs/${{github.run_id}})."
          bot_body: ":robot: A scheduled task has [triggered a merge](${{github.event.repository.html_url}}/actions/runs/${{github.run_id}})."
          bot: BrewTestBot

      - name: Set up Homebrew
        id: set-up-homebrew
        uses: Homebrew/actions/setup-homebrew@master

      # Workaround until the `cache` action uses the changes from
      # https://github.com/actions/toolkit/pull/580.
      - name: Unlink workspace
        run: |
          mv "${GITHUB_WORKSPACE}" "${GITHUB_WORKSPACE}-link"
          mkdir "${GITHUB_WORKSPACE}"

      - name: Cache gems
        uses: actions/cache@v2
        with:
          path: ${{steps.set-up-homebrew.outputs.gems-path}}
          key: ${{runner.os}}-rubygems-v2-${{steps.set-up-homebrew.outputs.gems-hash}}
          restore-keys: ${{runner.os}}-rubygems-v2-

      # Workaround until the `cache` action uses the changes from
      # https://github.com/actions/toolkit/pull/580.
      - name: Re-link workspace
        run: |
          rmdir "${GITHUB_WORKSPACE}"
          mv "${GITHUB_WORKSPACE}-link" "${GITHUB_WORKSPACE}"

      - name: Install gems
        run: brew install-bundler-gems

      - name: Configure Git user
        uses: Homebrew/actions/git-user-config@master

      - name: Set up commit signing
        uses: Homebrew/actions/setup-commit-signing@master
        with:
          signing_key: ${{ secrets.BREWTESTBOT_GPG_SIGNING_SUBKEY }}

      - name: Pull and upload bottles to GitHub Packages
        env:
          BREWTESTBOT_NAME_EMAIL: "BrewTestBot <1589480+BrewTestBot@users.noreply.github.com>"
          HOMEBREW_GPG_PASSPHRASE: ${{ secrets.BREWTESTBOT_GPG_SIGNING_SUBKEY_PASSPHRASE }}
          HOMEBREW_GITHUB_API_TOKEN: ${{secrets.HOMEBREW_CORE_PUBLIC_REPO_EMAIL_TOKEN}}
          HOMEBREW_GITHUB_PACKAGES_USER: brewtestbot
          HOMEBREW_GITHUB_PACKAGES_TOKEN: ${{secrets.HOMEBREW_CORE_GITHUB_PACKAGES_TOKEN}}
        run: brew pr-pull --debug --workflows=tests.yml --committer="$BREWTESTBOT_NAME_EMAIL" --root-url="https://ghcr.io/v2/homebrew/core" ${{github.event.inputs.args}} ${{github.event.inputs.pull_request}}

      - name: Push commits
        uses: Homebrew/actions/git-try-push@master
        with:
          token: ${{secrets.HOMEBREW_GITHUB_PUBLIC_REPO_TOKEN}}
        env:
          GIT_COMMITTER_NAME: BrewTestBot
          GIT_COMMITTER_EMAIL: 1589480+BrewTestBot@users.noreply.github.com
          HOMEBREW_GPG_PASSPHRASE: ${{ secrets.BREWTESTBOT_GPG_SIGNING_SUBKEY_PASSPHRASE }}

      - name: Post comment on failure
        if: ${{!success()}}
        uses: Homebrew/actions/post-comment@master
        with:
          token: ${{secrets.HOMEBREW_GITHUB_PUBLIC_REPO_TOKEN}}
          issue: ${{github.event.inputs.pull_request}}
          body: ":warning: @${{github.actor}} bottle publish [failed](${{github.event.repository.html_url}}/actions/runs/${{github.run_id}})."
          bot_body: ":warning: Bottle publish [failed](${{github.event.repository.html_url}}/actions/runs/${{github.run_id}})."
          bot: BrewTestBot

      - name: Dismiss approvals on failure
        if: ${{!success()}}
        uses: Homebrew/actions/dismiss-approvals@master
        with:
          token: ${{secrets.HOMEBREW_GITHUB_PUBLIC_REPO_TOKEN}}
          pr: ${{github.event.inputs.pull_request}}
          message: "bottle publish failed"

      # Workaround until the `cache` action uses the changes from
      # https://github.com/actions/toolkit/pull/580.
      - name: Unlink workspace
        run: |
          rm "${GITHUB_WORKSPACE}"
          mkdir "${GITHUB_WORKSPACE}"
