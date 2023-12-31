module.exports = async ({github, context, core}, formulae_detect) => {
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

    core.setOutput('syntax-only', syntax_only)
    if (syntax_only) {
      return
    }

    var linux_runner = 'ubuntu-22.04'
    if (label_names.includes('CI-linux-self-hosted')) {
      linux_runner = 'linux-self-hosted-1'
    } else if (label_names.includes('CI-linux-large-runner')) {
      linux_runner = 'homebrew-large-bottle-build'
    }
    core.setOutput('linux-runner', linux_runner)

    if (label_names.includes('CI-no-fail-fast')) {
      console.log('CI-no-fail-fast label found. Continuing tests despite failing matrix builds.')
      core.setOutput('fail-fast', false)
    } else {
      console.log('No CI-no-fail-fast label found. Stopping tests on first failing matrix build.')
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

    const maximum_long_pr_count = 2
    if (label_names.includes('CI-long-timeout')) {
      const labelCountQuery = `query($owner:String!, $name:String!, $label:String!) {
        repository(owner:$owner, name:$name) {
          pullRequests(last: 100, states: OPEN, labels: [$label]) {
            totalCount
          }
        }
      }`;
      var long_pr_count;
      try {
        const response = await github.graphql(
          labelCountQuery, {
            owner: context.repo.owner,
            name: context.repo.repo,
            label: 'CI-long-timeout'
          }
        )
        long_pr_count = response.repository.pullRequests.totalCount
      } catch (error) {
        // The GitHub API query errored, so fail open and assume 0 long PRs.
        long_pr_count = 0
        core.warning('CI-long-timeout label count query failed. Assuming no long PRs.')
      }
      if (long_pr_count > maximum_long_pr_count) {
        core.setFailed(`Too many pull requests (${long_pr_count}) with the long-timeout label!`)
        core.error(`Only ${maximum_long_pr_count} pull requests at a time can use this label.`)
        core.error('Remove the long-timeout label from this or other PRs (once their CI has completed).')
      }
      console.log('CI-long-timeout label found. Setting long GitHub Actions timeout.')
      core.setOutput('timeout-minutes', 4320)
    } else {
      console.log('No CI-long-timeout label found. Setting short GitHub Actions timeout.')
      core.setOutput('timeout-minutes', 90)

      if (label_names.includes('long build')) {
        core.setFailed('PR requires the CI-long-timeout label but it is not set!')
        core.error('If the longer timeout is not required, remove the "long build" label.')
        core.error('Otherwise, add the "CI-long-timeout" label.')
        core.error(`No more than ${maximum_long_pr_count} PRs at a time may use "CI-long-timeout".`)
      }
    }

    const test_bot_formulae_args = ["--only-formulae", "--junit", "--only-json-tab", "--skip-dependents"]
    test_bot_formulae_args.push(`--testing-formulae="${formulae_detect.testing_formulae}"`)
    test_bot_formulae_args.push(`--added-formulae="${formulae_detect.added_formulae}"`)
    test_bot_formulae_args.push(`--deleted-formulae="${formulae_detect.deleted_formulae}"`)

    const test_bot_dependents_args = ["--only-formulae-dependents", "--junit"]
    test_bot_dependents_args.push(`--testing-formulae="${formulae_detect.testing_formulae}"`)

    if (label_names.includes('CI-test-bot-fail-fast')) {
      console.log('CI-test-bot-fail-fast label found. Passing --fail-fast to brew test-bot.')
      test_bot_formulae_args.push('--fail-fast')
      test_bot_dependents_args.push('--fail-fast')
    } else {
      console.log('No CI-test-bot-fail-fast label found. Not passing --fail-fast to brew test-bot.')
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

    core.setOutput('test-bot-formulae-args', test_bot_formulae_args.join(" "))
    core.setOutput('test-bot-dependents-args', test_bot_dependents_args.join(" "))
}
