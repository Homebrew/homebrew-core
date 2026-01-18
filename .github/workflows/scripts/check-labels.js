module.exports = async ({github, context, core}, formulae_detect, dependent_testing) => {
    const deps_suffix = dependent_testing ? '-deps' : ''

    const { data: { labels: labels } } = await github.rest.pulls.get({
      owner: context.repo.owner,
      repo: context.repo.repo,
      pull_number: context.issue.number
    })
    const label_names = labels.map(label => label.name)
    var syntax_only = false

    if (label_names.includes('CI-syntax-only')) {
      console.log('CI-syntax-only label found. Skipping tests job.')
      syntax_only = true
    } else if (label_names.includes('CI-published-bottle-commits')) {
      console.log('CI-published-bottle-commits label found. Skipping tests job.')
      syntax_only = true
    } else {
      console.log('No CI-syntax-only label found. Running tests job.')
    }

    core.setOutput('nodejs', !syntax_only && label_names.includes('nodejs'))

    core.setOutput('syntax-only', syntax_only)
    if (syntax_only) {
      return
    }

    var linux_runner = 'ubuntu-latest'
    if (label_names.includes(`CI-linux-self-hosted${deps_suffix}`)) {
      linux_runner = 'linux-self-hosted-1'
    } else if (label_names.includes(`CI-linux-large-runner${deps_suffix}`)) {
      linux_runner = 'homebrew-large-bottle-build'
    }
    core.setOutput('linux-runner', linux_runner)

    if (label_names.includes(`CI-no-fail-fast${deps_suffix}`)) {
      console.log(`CI-no-fail-fast${deps_suffix} label found. Continuing tests despite failing matrix builds.`)
      core.setOutput('fail-fast', false)
    } else {
      console.log(`No CI-no-fail-fast${deps_suffix} label found. Stopping tests on first failing matrix build.`)
      core.setOutput('fail-fast', true)
    }

    if (label_names.includes('CI-skip-dependents')) {
      console.log('CI-skip-dependents label found. Skipping brew test-bot --only-formulae-dependents.')
      core.setOutput('test-dependents', false)
    } else if (!formulae_detect.testing_formulae) {
      console.log('No testing formulae found. Skipping brew test-bot --only-formulae-dependents.')
      core.setOutput('test-dependents', false)
    } else {
      console.log('No CI-skip-dependents label found. Running brew test-bot --only-formulae-dependents.')
      core.setOutput('test-dependents', true)
    }

    if (dependent_testing) {
      if (label_names.includes('long dependent tests')) {
        console.log('"long dependent tests" label found. Setting long GitHub Actions timeout.')
        core.setOutput('long-timeout', true)
      } else {
        console.log('No "long dependent tests" label found. Setting short GitHub Actions timeout.')
        core.setOutput('long-timeout', false)
      }
    } else {
      if (label_names.includes('long build')) {
        console.log('"long build" label found. Setting long GitHub Actions timeout.')
        core.setOutput('long-timeout', true)
      } else {
        console.log('No "long build" label found. Setting short GitHub Actions timeout.')
        core.setOutput('long-timeout', false)
      }
    }

    const test_bot_formulae_args = ["--only-formulae", "--junit", "--only-json-tab", "--skip-dependents"]
    const test_bot_dependents_args = ["--only-formulae-dependents", "--junit"]

    if (label_names.includes(`CI-test-bot-no-concurrent-downloads`)) {
      console.log(`CI-test-bot-no-concurrent-downloads label found. Running with HOMEBREW_DOWNLOAD_CONCURRENCY=1`)
      core.setOutput('download-concurrency', '1')
    } else {
      console.log(`No CI-test-bot-no-concurrent-downloads label found. Running with HOMEBREW_DOWNLOAD_CONCURRENCY=auto`)
      core.setOutput('download-concurrency', 'auto')
    }

    if (label_names.includes(`CI-test-bot-fail-fast${deps_suffix}`)) {
      console.log(`CI-test-bot-fail-fast${deps_suffix} label found. Passing --fail-fast to brew test-bot.`)
      test_bot_formulae_args.push('--fail-fast')
      test_bot_dependents_args.push('--fail-fast')
    } else {
      console.log(`No CI-test-bot-fail-fast${deps_suffix} label found. Not passing --fail-fast to brew test-bot.`)
    }

    if (label_names.includes('CI-build-dependents-from-source')) {
      console.log('CI-build-dependents-from-source label found. Passing --build-dependents-from-source to brew test-bot.')
      test_bot_dependents_args.push('--build-dependents-from-source')
    } else {
      console.log('No CI-build-dependents-from-source label found. Not passing --build-dependents-from-source to brew test-bot.')
    }

    if (label_names.includes('CI-skip-recursive-dependents')) {
      console.log('CI-skip-recursive-dependents label found. Passing --skip-recursive-dependents to brew test-bot.')
      test_bot_dependents_args.push('--skip-recursive-dependents')
    } else {
      console.log('No CI-skip-recursive-dependents label found. Not passing --skip-recursive-dependents to brew test-bot.')
    }

    if (label_names.includes('CI-skip-livecheck')) {
      console.log('CI-skip-livecheck label found. Passing --skip-livecheck to brew test-bot.')
      test_bot_formulae_args.push('--skip-livecheck')
    } else {
      console.log('No CI-skip-livecheck label found. Not passing --skip-livecheck to brew test-bot.')
    }

    if (label_names.includes('CI-version-downgrade')) {
      console.log('CI-version-downgrade label found. Passing --skip-stable-version-audit to brew test-bot.')
      test_bot_formulae_args.push('--skip-stable-version-audit')
    } else {
      console.log('No CI-version-downgrade label found. Not passing --skip-stable-version-audit to brew test-bot.')
    }

    if (label_names.includes('CI-checksum-change-confirmed')) {
      console.log('CI-checksum-change-confirmed label found. Passing --skip-checksum-only-audit to brew test-bot.')
      test_bot_formulae_args.push('--skip-checksum-only-audit')
    } else {
      console.log('No CI-checksum-change-confirmed label found. Not passing --skip-checksum-only-audit to brew test-bot.')
    }

    if (label_names.includes('CI-skip-revision-audit')) {
      console.log('CI-skip-revision-audit label found. Passing --skip-revision-audit to brew test-bot.')
      test_bot_formulae_args.push('--skip-revision-audit')
    } else {
      console.log('No CI-skip-revision-audit label found. Not passing --skip-revision-audit to brew test-bot.')
    }

    if (label_names.includes('CI-skip-new-formulae')) {
      console.log('CI-skip-new-formulae label found. Passing --skip-new to brew test-bot.')
      test_bot_formulae_args.push('--skip-new')
    } else {
      console.log('No CI-skip-new-formulae label found. Not passing --skip-new to brew test-bot.')
    }

    if (label_names.includes('CI-skip-new-formulae-strict')) {
      console.log('CI-skip-new-formulae-strict label found. Passing --skip-new-strict to brew test-bot.')
      test_bot_formulae_args.push('--skip-new-strict')
    } else {
      console.log('No CI-skip-new-formulae-strict label found. Not passing --skip-new-strict to brew test-bot.')
    }

    core.setOutput('test-bot-formulae-args', test_bot_formulae_args.join(" "))
    core.setOutput('test-bot-dependents-args', test_bot_dependents_args.join(" "))
}
